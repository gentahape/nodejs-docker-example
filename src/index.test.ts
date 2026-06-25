import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from './index';

describe('GET /', () => {
  it('returns a JSON greeting', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ message: 'Hello World' });
  });
});