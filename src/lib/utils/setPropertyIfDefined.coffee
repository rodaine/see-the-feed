###*
 * Currying function for assigning properties from a source object if they are defined
 * @param {object} src      The source object to pull a property from
 * @param {object} dest     The destination object to assign the pulled property to
 * @param {string} srcProp  The property name on the source to copy
 * @param {string} destProp The property name on the destination to copy to
###
module.exports = (src, dest) -> (srcProp, destProp) ->
	dest[destProp] = src[srcProp] if src[srcProp]?
