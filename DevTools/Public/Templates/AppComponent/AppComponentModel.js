define([
	"can",
	"defines",
], function (can, defines) {
	"use strict"

	return can.Model.extend(
		/* static */
		{
			//findOne: require.toUrl("~/api/<CONTROLLER>"),
			//findAll: require.toUrl("~/api/<CONTROLLER>"),
			//create: require.toUrl("~/api/<CONTROLLER>"),
			//update: require.toUrl("~/api/<CONTROLLER>"),
		},
		/* prototype */
		{
			v2: true,
			define: {

			}
		}
	);
});