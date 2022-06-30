const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const path = require('path');
require('./db_config');
require('./jwt_utils');
const {generateJwt} = require("./jwt_utils");
const {checkUsername, checkEmail, checkPassword} = require("./utils");

app.use(bodyParser.json({limit: '100mb'}));
app.use(bodyParser.urlencoded({limit: '100mb', extended: true}));

// Customer Login Endpoint
app.post('/api/customer/login', (req, res) => {
    const {username, password} = req.body;
    if (!username || !password) {
        res.status(400).send("Bad Request");
        return;
    }
    const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;
    db.one(query)
        .then(user => {
            const token = generateJwt({id: user.id, username: user.username});
            res.json({
                token: token, message: "Login Successful", success: true, code: 200
            });
        })
        .catch(err => {
            res.status(200).json({message: 'Invalid username or password', success: false, code: 200});
        });
});

// Customer Register Endpoint
app.post('/api/customer/register', (req, res) => {
    const {username, password, email} = req.body;
    if (!username || !password || !email) {
        return res.status(400).send("Bad Request");
    } else if (!checkUsername(username)) {
        return res.status(400).json({message: 'Invalid username', success: false, code: 200});
    } else if (!checkPassword(password)) {
        return res.status(400).json({message: 'Invalid password', success: false, code: 200});
    } else if (!checkEmail(email)) {
        return res.status(400).json({message: 'Invalid email', success: false, code: 200});
    }
    let query = `SELECT * FROM users WHERE username = '${username}'`;
    db.one(query)
        .then(user => {
                res.status(200).json({message: 'Username already exists', success: false, code: 200});
            }
        ).catch(err => {
            query = `INSERT INTO users (username, password, email) VALUES ('${username}', '${password}', '${email}')`;
            db.none(query)
                .then(() => {
                    return res.status(200).json({message: 'Registration Successful', success: true, code: 200});
                }).catch(err => {
                    return res.status(200).json({message: 'Registration Failed', success: false, code: 200});
                }
            );
        }
    )

});

// Store Owner Login Endpoint
app.post('/api/owner/login', (req, res) => {
    const {username, password} = req.body;
    if (!username || !password) {
        res.status(400).send("Bad Request");
        return;
    }
    const query = `SELECT * FROM owner WHERE username = '${username}' AND password = '${password}'`;
    db.one(query)
        .then(user => {
            const token = generateJwt({id: user.id, username: user.username});
            res.json({
                token: token, message: "Login Successful", success: true, code: 200
            });
        }).catch(err => {
            res.status(200).json({message: 'Invalid username or password', success: false, code: 200});
        }
    );
});

// Get Categories & Subcategories Endpoint
app.get('/api/categories', (req, res) => {
    const query = `SELECT * FROM category`;
    db.any(query)
        .then(categories => {
            let categories_list = [];
            categories.forEach(category => {
                if (category.parent_id === null) {
                    categories_list.push(category);
                } else {
                    let parent_category = categories_list.find(cat => cat.id === category.parent_id);
                    if (parent_category) {
                        if (!parent_category.subcategories) {
                            parent_category.subcategories = [];
                        }
                        parent_category.subcategories.push(category);
                    }
                }
            })
            res.json({categories: categories_list, success: true, code: 200});
        }).catch(err => {
            res.status(200).json({message: 'Failed to get categories', success: false, code: 200});
        }
    );
});

app.listen(8080);
console.log(`[\x1b[90m${new Date().toTimeString().split(' ')[0]}\x1b[0m] Server is listening on port 8080`);