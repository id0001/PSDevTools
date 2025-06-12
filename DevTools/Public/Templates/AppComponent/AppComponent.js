define([
	"AppComponent",
	"defines",
	"globalize",
	"navigation",
	>>> Model
	"stache!./<# Name #>.stache"
], function (AppComponent, defines, globalize, navigation,<# Model #> VIEW) {
	"use strict"
	
	return AppComponent.extend({
		tag: "<# Tag #>",
		template: VIEW,
		leakScope: false,
		viewModel: {
			v2: true,
			title: globalize.translate("<# ResourceKey #>.title"),
			define: {
				resourceKey: { value: "<# ResourceKey #>" },

				loaded: defines.bool
			},
			
			init: function () {
				this.load();
			},
			
			load: function () {
				var me = this;
				me.attr("loaded", false);
			}
		},
		helpers: {},
		events: {}
	});
});