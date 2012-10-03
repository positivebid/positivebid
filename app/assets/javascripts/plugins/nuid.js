// NUUID - Nijiko's Universal? Unique Identifier
// http://twitter.com/nijikokun - (c) a: Nijikokun l: AOL y: 2012
//
// It's been tested against uuid and is universally faster with zero collisions thus far.
// No RFC or SPEC, Simple unique id with secret key support, not dependent on an internal "clock"
//
// Made it even more performant.
//
// Test with collision detection: 
//   http://jsfiddle.net/HX3nL/3/
//
// Testing against node-uuid:
//   http://jsperf.com/node-uuid-performance/7
//
// Sections:
// 1. time >> 45 + Random ( new Time >> 20 )
// 2. (time >> 32) -> sum of all numbers
// 3. (secret - sum of all chars/numbers || 0) + Random ( time >> 40 ) + Random ( new Time >> 42 )
// 4. ( time >> 8 )
!(function (context) {
  // Coded at this level of minification, this is the ACTUAL source.
  context.nuid = function(c,a,b,d,e,f,g,h,i,j,k) {
    d = +new Date; e = 0; f = d >> 32; h = d >> 45; i = d >> 8;
    g = ~~(0.5 + (Math.random() * (d >> 40)));
    j = ~~(0.5 + (Math.random() * (d >> 42)));
    k = ~~(0.5 + (Math.random() * (d >> 20)));
    for(b = 0;b < f.length;b++) e += +a[b];
    a = g;
    if(c) if(typeof c === "string") for(b = 0;b < c.length;b++) a += +(c.charCodeAt(b));
    a += j;
    return h + k + "-" + e + "-" + a + "-" + i;
  };
})(
  (typeof modules !== 'undefined') ? ((modules.exports) ? module.exports : window) : window
);
  