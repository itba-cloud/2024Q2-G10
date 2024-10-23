import {clientId, userPoolId} from "../lib/cognito";
import {CognitoUserPool} from "amazon-cognito-identity-js";

const poolData = {
    UserPoolId: userPoolId,
    ClientId: clientId
};

console.log(poolData);

export const UserPool = new CognitoUserPool(poolData);

export const signUp = (email: string, password: string) => {
    UserPool.signUp(
        email,
        password,
        [],
        [],
        (err, data) => {
            if (err) console.error(err);
            console.log(data);
        }
    );
}

