const request = require("supertest");
const app = require("../app");

describe("User API Tests", () => {

  // Test GET all users
  it("should get all users", async () => {
    const res = await request(app).get("/api/users");

    expect(res.statusCode).toBe(200);
    expect(res.body).toBeInstanceOf(Array);
  });

  // Test POST user
  it("should create a new user", async () => {
    const res = await request(app)
      .post("/api/users")
      .send({ name: "Charlie" });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty("name", "Charlie");
    expect(res.body).toHaveProperty("id");
  });

  // Test GET user by ID
  it("should get user by id", async () => {
    // First create a user
    const createRes = await request(app)
      .post("/api/users")
      .send({ name: "John" });

    const userId = createRes.body.id;

    // Now fetch it
    const getRes = await request(app).get(`/api/users/${userId}`);

    expect(getRes.statusCode).toBe(200);
    expect(getRes.body.name).toBe("John");
  });

  // Test user not found
  it("should return 404 for invalid user id", async () => {
    const res = await request(app).get("/api/users/99999");

    expect(res.statusCode).toBe(404);
  });

});
