# POC Architecture

## System Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   GitHub    │────▶│   Lambda    │────▶│   OpenAI    │
│  Webhooks   │     │  Function   │     │    API      │
└─────────────┘     └──────┬──────┘     └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │   GitHub    │
                   │  Comments   │
                   └──────┬──────┘
                          │
                          ▼
                   ┌─────────────┐
                   │    Slack    │
                   │  Summary    │
                   └─────────────┘
```

## Components

### 1. GitHub App (Webhook Receiver)

**Purpose**: Receive PR events and trigger review pipeline

**Configuration**:
- Events: `pull_request.opened`, `pull_request.synchronize`
- Permissions: `contents: read`, `pull_requests: write`
- Webhook URL: API Gateway endpoint

**Limitations in POC**:
- Single organization only
- No event filtering (reviews all PRs)
- No queue - direct invocation

### 2. Lambda Function (Orchestrator)

**Purpose**: Coordinate review process

**Runtime**: Python 3.11
**Memory**: 512MB
**Timeout**: 60 seconds

**Flow**:
```python
def handler(event):
    pr_data = parse_webhook(event)
    diff = fetch_pr_diff(pr_data)
    context = fetch_context_files(pr_data, diff)

    reviews = []
    for category in ['security', 'performance', 'style']:
        prompt = build_prompt(category, diff, context)
        result = call_openai(prompt)
        reviews.extend(parse_review(result))

    post_comments(pr_data, reviews)
    send_slack_summary(pr_data, reviews)
```

**Dependencies**:
- `openai` - LLM API client
- `PyGithub` - GitHub API client
- `slack_sdk` - Slack notifications

### 3. Prompt System

**Structure**: Category-specific prompts with shared preamble

**Security Prompt** (excerpt):
```
You are a senior security engineer reviewing code for vulnerabilities.
Focus on: SQL injection, XSS, SSRF, authentication bypass, secrets exposure.

For each issue found, respond with JSON:
{
  "file": "path/to/file.py",
  "line": 42,
  "severity": "high|medium|low",
  "category": "sql_injection",
  "description": "User input passed directly to query",
  "suggestion": "Use parameterized queries",
  "confidence": 8
}
```

**Context Strategy**:
- Include full diff
- Include imported files (up to 3)
- Include called functions (up to 5)
- Max context: 6000 tokens

### 4. Comment Formatting

**Template**:
```markdown
🔒 **Security Issue** (High Confidence)

**Category**: SQL Injection
**Severity**: High

User input from `request.args['id']` is passed directly to SQL query without sanitization.

**Suggestion**: Use parameterized queries:
```python
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

---
*AI Code Review (GPT-4) • [Report false positive](link)*
```

### 5. Slack Integration

**Summary format**:
```
📊 AI Code Review Summary for PR #142

Security: 2 issues (1 high, 1 medium)
Performance: 1 issue (medium)
Style: 3 suggestions

View PR: https://github.com/org/repo/pull/142
```

## Data Flow

```
1. Developer opens PR
2. GitHub sends webhook to API Gateway
3. API Gateway triggers Lambda
4. Lambda fetches PR diff via GitHub API
5. Lambda fetches context files
6. Lambda sends 3 prompts to OpenAI (sequential)
7. Lambda parses responses
8. Lambda posts comments to PR
9. Lambda sends Slack summary
10. Developer sees comments on PR
```

## Infrastructure (POC)

| Component | Service | Cost |
|-----------|---------|------|
| Webhook endpoint | API Gateway | Free tier |
| Orchestration | Lambda | ~$6/month |
| Secrets | Secrets Manager | $0.40/month |
| Logs | CloudWatch | ~$5/month |

## Security Considerations

### Secrets Management
- OpenAI API key in Secrets Manager
- GitHub App private key in Secrets Manager
- Slack webhook URL in environment variable (should move)

### Data Handling
- PR diffs are not persisted
- No PII logging
- Comments include "AI generated" disclaimer

### Access Control
- Lambda has minimal IAM role
- GitHub App has read-only repo access + PR write
- No cross-account access

## Known Architecture Issues

1. **No queue**: Direct webhook-to-Lambda means lost events during outages
2. **Sequential LLM calls**: 3 calls per PR, could parallelize
3. **No caching**: Repeated reviews of same code
4. **No rate limiting**: Vulnerable to webhook floods
5. **Synchronous Slack**: Blocks on notification delivery
6. **Single region**: No failover

## Production Architecture (Proposed)

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   GitHub    │────▶│     SQS     │────▶│   Lambda    │
│  Webhooks   │     │   Queue     │     │  Workers    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
       ┌───────────────────────────────────────┤
       │                                       │
       ▼                                       ▼
┌─────────────┐                         ┌─────────────┐
│  DynamoDB   │                         │   OpenAI    │
│  (results)  │                         │    API      │
└─────────────┘                         └─────────────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│   GitHub    │     │    Slack    │
│  Comments   │     │  Summary    │
└─────────────┘     └─────────────┘
```

**Key changes for production**:
- SQS queue for reliability
- DynamoDB for result caching and analytics
- Parallel LLM calls
- Dead letter queue for failures
- Multi-region deployment
