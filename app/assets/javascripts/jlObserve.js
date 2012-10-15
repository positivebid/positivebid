
$.fn.jl_observe = function(ms, fn){
  return this.each(function(){

    var $e = $(this);
    var int_id;

    fn(); // run once now

    $e.focus( function(){
      int_id = setInterval( fn, ms);
    });

    $e.blur( function(){
      clearInterval(int_id);
    });

    $e.change(fn);

  });
};

