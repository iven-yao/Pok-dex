const { pool } = require('../config/db');
const bcrypt = require('bcryptjs');

class User {
  static async create(username, email, password) {
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING id, username, email',
      [username, email, hashedPassword]
    );
    return result.rows[0];
  }

  static async findByEmail(email) {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0];
  }

  static async findById(id) {
    const result = await pool.query('SELECT id, username, email, refresh_token FROM users WHERE id = $1', [id]);
    return result.rows[0];
  }

  static async updateProfile(id, username, email) {
    const result = await pool.query(
      'UPDATE users SET username = $1, email = $2 WHERE id = $3 RETURNING id, username, email',
      [username, email, id]
    );
    return result.rows[0];
  }

  static async changePassword(id, newPassword) {
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await pool.query('UPDATE users SET password = $1 WHERE id = $2', [hashedPassword, id]);
  }

  static async renewRefreshToken(id, token) {
    await pool.query('UPDATE users SET refresh_token = $1 WHERE id = $2', [token, id]);
  }

  static async removeRefreshToken(id) {
    await pool.query('UPDATE users SET refresh_token = NULL WHERE id = $1',[id]);
  }

  static async getUserName(id) {
    const result = await pool.query('SELECT username FROM users WHERE id = $1',[id]);
    return result.rows[0];
  }
}

module.exports = User;