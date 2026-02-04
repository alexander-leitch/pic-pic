<?php

return [
    'provider' => env('SSO_PROVIDER', 'google'),
    'client_id' => env('SSO_CLIENT_ID'),
    'client_secret' => env('SSO_CLIENT_SECRET'),
    'redirect' => env('SSO_REDIRECT_URI'),
];
