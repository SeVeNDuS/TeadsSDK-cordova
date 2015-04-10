cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/tv.teads.sdk/www/TeadsPlugin.js",
        "id": "tv.teads.sdk.TeadsPlugin",
        "clobbers": [
            "Teads"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "tv.teads.sdk": "1.0",
    "com.google.playservices": "21.0.0",
    "android.support.v4": "21.0.1",
    "android.support.v7-appcompat": "1.0.0"
}
// BOTTOM OF METADATA
});