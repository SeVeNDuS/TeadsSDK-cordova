cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/tv.teads.sdk/www/TeadsPlugin.js",
        "id": "tv.teads.sdk.TeadsPlugin",
        "clobbers": [
            "TeadsSDK"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.0.1-dev",
    "tv.teads.sdk": "1.0.1"
}
// BOTTOM OF METADATA
});