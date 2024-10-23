#!/bin/bash

echo "export const url = '$API_ENDPOINT'" > ./src/lib/api.ts
echo "export const userPoolId = '$USER_POOL_ID'" > ./src/lib/cognito.ts
echo "export const clientId = '$CLIENT_ID'" >> ./src/lib/cognito.ts
echo "export const region = '$REGION'" >> ./src/lib/cognito.ts

npm ci
npm run build