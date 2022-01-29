const jwt = require("jsonwebtoken");
const app_config = require("../app_config.json");

function UserAuthentication(req, res, next){
    if (!req.header('x-auth-token')) return res.status(401).send('No token found!')

    try
    {
        req.user = jwt.verify(req.header('x-auth-token'), app_config.jwtKey);
        next();
    }

    catch (ex)
    {
        res.status(400).send('Invalid Token!!');
    }
}
exports.UserAuthentication = UserAuthentication;