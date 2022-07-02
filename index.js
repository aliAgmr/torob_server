const express = require('express');
const app = express();
const bodyParser = require('body-parser');
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
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT * FROM customer WHERE username = '${username}' AND password = '${password}'`;
    db.one(query)
        .then(user => {
            const token = generateJwt({id: user.id, username: user.username});
            return res.json({
                body: {token: token, user: user}, message: "ورود موفق", success: true, code: 200
            });
        })
        .catch(_ => {
            return res.status(200).json({message: 'نام کاربری یا رمز عبور اشتباه است', success: false, code: 200});
        });
});

// Customer Register Endpoint
app.post('/api/customer/register', (req, res) => {
    const {username, password, email} = req.body;
    if (!username || !password || !email) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    } else if (!checkUsername(username)) {
        return res.status(400).json({message: 'نام کاربری غیرمجاز', success: false, code: 200});
    } else if (!checkPassword(password)) {
        return res.status(400).json({message: 'رمز عبور غیر مجاز', success: false, code: 200});
    } else if (!checkEmail(email)) {
        return res.status(400).json({message: 'ایمیل غیرمجاز', success: false, code: 200});
    }
    let query = `SELECT * FROM customer WHERE username = '${username}'`;
    db.one(query)
        .then(_ => {
            return res.status(200).json({message: 'نام کاربری تکراری است', success: false, code: 200});
        }).catch(_ => {
        query = `INSERT INTO customer (username, password, email) VALUES ('${username}', '${password}', '${email}') RETURNING *`;
        db.one(query)
            .then(user => {
                const token = generateJwt({id: user.id, username: user.username});
                return res.status(200).json({
                    body: {token: token, user: user}, message: 'ثبت‌نام موفق', success: true, code: 200
                });
            }).catch(_ => {
            return res.status(200).json({message: 'مشکلی در ثبت‌نام بوجود آمد.', success: false, code: 200});
        });
    })

});

// Store Owner Login Endpoint
app.post('/api/owner/login', (req, res) => {
    const {username, password} = req.body;
    if (!username || !password) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT * FROM owner WHERE username = '${username}' AND password = '${password}'`;
    db.one(query)
        .then(owner => {
            const token = generateJwt({id: owner.id, username: owner.username});
            return res.json({
                body: {token: token, user: owner}, message: "ورود موفق", success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'نام کاربری یا رمز عبور اشتباه است', success: false, code: 200});
    });
});

// Get Products Endpoint
app.get('/api/products', (req, res) => {
    const category_id = req.query.category_id;
    let query = `SELECT name,
                       description,
                       category_id,
                       processor,
                       ram,
                       battery,
                       dimensions,
                       product_id,
                       price
                FROM product
                LEFT JOIN store_product sp ON product.id = sp.product_id`;
    if (category_id) {
        query += ` WHERE category_id = ${category_id} ORDER BY price`;
    } else {
        query += ` ORDER BY price`;
    }
    db.any(query)
        .then(products => {
            let filteredProducts = [];
            products.forEach(product => {
                if (filteredProducts.find(p => p.product_id === product.product_id)) {
                    filteredProducts[filteredProducts.findIndex(p => p.product_id === product.product_id)].max_price = product.price;
                } else {
                    filteredProducts.push({...product, min_price: product.price, max_price: product.price});
                }
            });
            return res.json({
                body: {
                    products: filteredProducts
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن محصولات', success: false, code: 200});
    });
});

// Get product details Endpoint
app.get('/api/product/:id', (req, res) => {
    const product_id = req.params.id;
    if (!product_id) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT product.name,
                           product.description,
                           product.category_id,
                           product.processor,
                           product.ram,
                           product.battery,
                           product.dimensions,
                           sp.price       as price,
                           sp.link        as product_link,
                           s.id           as store_id,
                           s.name         as store_name,
                           s.link         as store_link,
                           s.phone_number as store_number,
                           s.address      as store_address
                    FROM product
                    LEFT JOIN store_product sp ON product.id = sp.product_id
                    LEFT JOIN store s on s.id = sp.store_id
                    WHERE product_id = ${product_id}`;
    db.many(query)
        .then(product => {
            return res.json({
                body: {
                    product: product
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن محصول', success: false, code: 200});
    });
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
            return res.json({
                body: {
                    categories: categories_list
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن دسته‌بندی‌ها', success: false, code: 200});
    });
});

// Submit Store Report
app.post('/api/store/report', (req, res) => {
    const {store_id, report_type, customer_id, product_id} = req.body;
    if (!store_id || !report_type || !customer_id || !product_id) {
        return res.status(400).json({
            store_id: store_id,
            message: 'لطفا همه فیلدها را به درستی وارد نمایید',
            success: false,
            code: 400
        });
    }
    const query = `INSERT INTO report (store_id, report_type, customer_id, product_id) VALUES (${store_id}, ${report_type}, ${customer_id}, ${product_id})`;
    db.none(query)
        .then(() => {
            return res.status(200).json({
                message: 'گزارش موفق', success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({
            message: _.message, success: false, code: 200
        });
    });
});

// Get Store reports
app.get('/api/store/report', (req, res) => {
    const {store_id} = req.body;
    if (!store_id) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT * FROM report WHERE store_id = ${store_id}`;
    db.any(query)
        .then(reports => {
            return res.json({
                body: {
                    reports: reports
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن گزارش‌ها', success: false, code: 200});
    });
})

// Add or Remove Product From Favorite List
app.post('/api/product/favorite', (req, res) => {
    const {product_id, customer_id, state} = req.body;
    if (!product_id || !customer_id || !state) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    let query = '';
    if (state === 'true') {
        query = `INSERT INTO customer_favorite_product (product_id, customer_id) VALUES (${product_id}, ${customer_id})`;
        //     check if product is already in favorite list
        db.one(`SELECT * FROM customer_favorite_product WHERE product_id = ${product_id} AND customer_id = ${customer_id}`)
            .then(_ => {
                return res.status(200).json({
                    message: 'محصول در لیست موردعلاقه‌ها وجود دارد.',
                    success: false,
                    code: 200
                });
            }).catch(_ => {
            db.none(query)
                .then(() => {
                    return res.status(200).json({
                        body: null, message: 'محصول به لیست موردعلاقه‌ها افزوده شد.', success: true, code: 200
                    });
                }).catch(_ => {
                return res.status(200).json({
                    message: 'مشکلی در ثبت محصول بوجود آمد.', success: false, code: 200
                });
            });
        })
    } else {
        query = `DELETE FROM customer_favorite_product WHERE product_id = ${product_id} AND customer_id = ${customer_id}`;
        // check if product is in favorite list
        db.one(`SELECT * FROM customer_favorite_product WHERE product_id = ${product_id} AND customer_id = ${customer_id}`)
            .then(_ => {
                db.none(query)
                    .then(() => {
                        return res.status(200).json({
                            body: null, message: 'محصول از لیست موردعلاقه‌ها حذف شد.', success: true, code: 200
                        });
                    }).catch(_ => {
                    return res.status(200).json({
                        message: 'مشکل در گرفتن لیست موردعلاقه‌ها', success: false, code: 200
                    });
                });
            }).catch(_ => {
            return res.status(200).json({message: 'محصول در لیست موردعلاقه‌ها نیست.', success: false, code: 200});
        })
    }
})

// Get Customer Favorite Products
app.get('/api/customer/favorite/:customer_id', (req, res) => {
    const {customer_id} = req.params;
    if (!customer_id) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT product.id
                    FROM product
                    LEFT JOIN customer_favorite_product f ON product.id = f.product_id
                    WHERE f.customer_id = ${customer_id}`;
    db.any(query)
        .then(products => {
            return res.json({
                body: {
                    products: products.map(product => product.id)
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن لیست موردعلاقه‌ها', success: false, code: 200});
    });
});

// Add Store
app.post('/api/store', (req, res) => {
    const {name, phone_number, address, link, owner_id} = req.body;
    if (!name || !phone_number || !address || !link || !owner_id) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    db.one(`SELECT * FROM owner WHERE id = ${owner_id}`)
        .then(_ => {
            const query = `INSERT INTO store (name, phone_number, address, link, owner_id) VALUES ('${name}', '${phone_number}', '${address}', '${link}', ${owner_id})`;
            db.none(query)
                .then(() => {
                    return res.status(200).json({
                        body: null, message: 'فروشگاه با موفقیت افزوده شد.', success: true, code: 200
                    });
                }).catch(_ => {
                return res.status(200).json({message: 'مشکل در ثبت فروشگاه', success: false, code: 200});
            });
        })
        .catch(_ => {
            return res.status(200).json({message: 'صاحب فروشگاه وجود ندارد.', success: false, code: 200});
        })
});

// Get Owner Stores + Products + Reports
app.get('/api/owner/stores/:owner_id', (req, res) => {
    const {owner_id} = req.params;
    if (!owner_id) {
        return res.status(400).json({message: 'لطفا همه فیلدها را به درستی وارد نمایید', success: false, code: 400});
    }
    const query = `SELECT store.id,
                           store.name,
                           store.link,
                           store.phone_number,
                           store.address,
                           json_agg(DISTINCT jsonb_build_object(
                                   'id', r.id, 'report_type', r.report_type, 'product_id', r.product_id
                               )) AS reports,
                           json_agg(DISTINCT jsonb_build_object(
                                   'id', sp.id, 'price', sp.price, 'product_link', sp.link
                               )) AS products
                    FROM store
                             LEFT JOIN report r on store.id = r.store_id
                             LEFT JOIN store_product sp on store.id = sp.store_id
                    WHERE store.owner_id = 1000
                    GROUP BY store.id`;
    db.any(query)
        .then(stores => {
            return res.json({
                body: {
                    stores: stores
                }, success: true, code: 200
            });
        }).catch(_ => {
        return res.status(200).json({message: 'مشکل در گرفتن لیست فروشگاه ها', success: false, code: 200})

    });
});

app.listen(8080);
console.log(`[\x1b[90m${new Date().toTimeString().split(' ')[0]}\x1b[0m] Server is listening on port 8080`);