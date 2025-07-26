const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to Kubernetes Ingress Demo!',
        timestamp: new Date().toISOString(),
        hostname: require('os').hostname(),
        version: process.env.APP_VERSION || '1.0.0'
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

app.get('/api/users', (req, res) => {
    res.json({
        users: [
            { id: 1, name: 'Alice', email: 'alice@example.com' },
            { id: 2, name: 'Bob', email: 'bob@example.com' }
        ]
    });
});

app.get('/api/info', (req, res) => {
    res.json({
        environment: process.env.NODE_ENV || 'development',
        database_url: process.env.DB_URL || 'not configured',
        redis_url: process.env.REDIS_URL || 'not configured'
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});
