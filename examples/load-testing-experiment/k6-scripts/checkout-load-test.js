/**
 * k6 Load Test Script: Checkout Flow
 *
 * Tests the full checkout flow under various load conditions.
 * Simulates realistic user behavior with browse, cart, and checkout actions.
 */

import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const checkoutErrors = new Rate('checkout_errors');
const checkoutDuration = new Trend('checkout_duration');
const inventoryCheckDuration = new Trend('inventory_check_duration');

// Test configuration
export const options = {
  scenarios: {
    // Ramp up to target load
    load_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '5m', target: 2500 },   // Ramp to 2,500
        { duration: '5m', target: 2500 },   // Hold
        { duration: '5m', target: 5000 },   // Ramp to 5,000
        { duration: '5m', target: 5000 },   // Hold
        { duration: '5m', target: 7500 },   // Ramp to 7,500
        { duration: '5m', target: 7500 },   // Hold
        { duration: '5m', target: 10000 },  // Ramp to 10,000
        { duration: '5m', target: 10000 },  // Hold
        { duration: '5m', target: 0 },      // Ramp down
      ],
    },
  },
  thresholds: {
    http_req_duration: ['p(99)<2000'],     // 99th percentile < 2s
    http_req_failed: ['rate<0.001'],        // Error rate < 0.1%
    checkout_errors: ['rate<0.001'],        // Checkout errors < 0.1%
    checkout_duration: ['p(99)<3000'],      // Checkout p99 < 3s
  },
};

// Test configuration
const BASE_URL = __ENV.BASE_URL || 'https://test.example.com';
const PRODUCTS = JSON.parse(open('./test-data/products.json'));
const USERS = JSON.parse(open('./test-data/users.json'));

/**
 * Main test function - simulates realistic user journey
 */
export default function() {
  const user = USERS[Math.floor(Math.random() * USERS.length)];
  const action = weightedRandomAction();

  switch (action) {
    case 'browse':
      browseProducts();
      break;
    case 'cart':
      addToCart(user);
      break;
    case 'checkout':
      fullCheckout(user);
      break;
  }

  // Think time between actions
  sleep(Math.random() * 3 + 1); // 1-4 seconds
}

/**
 * Weighted random action selection
 * 60% browse, 25% cart, 15% checkout
 */
function weightedRandomAction() {
  const rand = Math.random();
  if (rand < 0.60) return 'browse';
  if (rand < 0.85) return 'cart';
  return 'checkout';
}

/**
 * Browse products flow
 */
function browseProducts() {
  // Get product listing
  const listRes = http.get(`${BASE_URL}/api/products?page=1&limit=20`, {
    tags: { name: 'GET /products' },
  });

  check(listRes, {
    'product list status is 200': (r) => r.status === 200,
    'product list has items': (r) => JSON.parse(r.body).products.length > 0,
  });

  sleep(0.5);

  // Get single product detail
  const productId = PRODUCTS[Math.floor(Math.random() * PRODUCTS.length)].id;
  const detailRes = http.get(`${BASE_URL}/api/products/${productId}`, {
    tags: { name: 'GET /products/:id' },
  });

  check(detailRes, {
    'product detail status is 200': (r) => r.status === 200,
  });
}

/**
 * Add to cart flow
 */
function addToCart(user) {
  const product = PRODUCTS[Math.floor(Math.random() * PRODUCTS.length)];

  const res = http.post(
    `${BASE_URL}/api/cart`,
    JSON.stringify({
      product_id: product.id,
      quantity: Math.floor(Math.random() * 3) + 1,
    }),
    {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${user.token}`,
      },
      tags: { name: 'POST /cart' },
    }
  );

  check(res, {
    'add to cart status is 200': (r) => r.status === 200,
    'cart updated': (r) => JSON.parse(r.body).success === true,
  });
}

/**
 * Full checkout flow
 */
function fullCheckout(user) {
  const startTime = Date.now();

  // Step 1: Add item to cart
  const product = PRODUCTS[Math.floor(Math.random() * PRODUCTS.length)];

  http.post(
    `${BASE_URL}/api/cart`,
    JSON.stringify({ product_id: product.id, quantity: 1 }),
    {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${user.token}`,
      },
      tags: { name: 'POST /cart (checkout flow)' },
    }
  );

  sleep(0.5);

  // Step 2: Check inventory
  const inventoryStart = Date.now();
  const inventoryRes = http.get(
    `${BASE_URL}/api/inventory/check?product_id=${product.id}`,
    {
      headers: { 'Authorization': `Bearer ${user.token}` },
      tags: { name: 'GET /inventory/check' },
    }
  );
  inventoryCheckDuration.add(Date.now() - inventoryStart);

  if (inventoryRes.status !== 200) {
    checkoutErrors.add(1);
    return;
  }

  sleep(0.3);

  // Step 3: Submit checkout
  const checkoutRes = http.post(
    `${BASE_URL}/api/checkout`,
    JSON.stringify({
      shipping_address: user.address,
      payment_method: user.payment_method,
    }),
    {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${user.token}`,
      },
      tags: { name: 'POST /checkout' },
      timeout: '30s',
    }
  );

  const checkoutSuccess = check(checkoutRes, {
    'checkout status is 200': (r) => r.status === 200,
    'order created': (r) => {
      try {
        return JSON.parse(r.body).order_id !== undefined;
      } catch {
        return false;
      }
    },
  });

  checkoutErrors.add(checkoutSuccess ? 0 : 1);
  checkoutDuration.add(Date.now() - startTime);
}

/**
 * Setup function - runs once before test
 */
export function setup() {
  console.log('Starting load test...');
  console.log(`Target URL: ${BASE_URL}`);
  console.log(`Test users: ${USERS.length}`);
  console.log(`Test products: ${PRODUCTS.length}`);

  // Verify connectivity
  const healthRes = http.get(`${BASE_URL}/health`);
  if (healthRes.status !== 200) {
    throw new Error('Target not healthy');
  }

  return { startTime: Date.now() };
}

/**
 * Teardown function - runs once after test
 */
export function teardown(data) {
  const duration = (Date.now() - data.startTime) / 1000 / 60;
  console.log(`Test completed in ${duration.toFixed(2)} minutes`);
}
