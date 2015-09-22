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
    "cordova-plugin-whitelist": "1.0.0",
    "tv.teads.sdk": "1.2.0"
}
// BOTTOM OF METADATA
});