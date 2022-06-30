function checkEmail(email) {
    let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function checkUsername(username) {
    let re = /^\w+$/;
    return re.test(username);
}

function checkPassword(password) {
    // At Least one number, one lowercase and one uppercase letter & 8 characters long
    let re = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
    return re.test(password);
}

module.exports = {
    checkEmail,
    checkUsername,
    checkPassword
}