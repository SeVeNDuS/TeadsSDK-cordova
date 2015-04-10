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
    "tv.teads.sdk": "1.0"
}
// BOTTOM OF METADATA
});