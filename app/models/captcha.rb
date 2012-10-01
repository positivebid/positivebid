class Captcha
  DB = [ 
    { :q => '1 &#43; 1 + 1', :a => 3 },
    { :q => '1 &#43; 0', :a => 1 },
    { :q => '1 + 1 &#43; 2', :a => 4 },
    { :q => '1 &#43; 1 + 2', :a => 4 },
    { :q => '1 &#43; 1', :a => 2 },
    { :q => '4 &nbsp; plus 4', :a => 8},
    { :q => '4 &#43; 2', :a => 6},
    { :q => '0 &nbsp; +  0', :a => 0},
    { :q => '4 &mdash; 1', :a => 3},
    { :q => '4 minus 0', :a => 4},
    { :q => '4 minus 2', :a => 2},
    { :q => '9 minus 2', :a => 7},
    { :q => '9 &mdash; 2', :a => 7},
    { :q => '3 minus 2', :a => 1},
    { :q => '4 &ndash;  1', :a => 3},
    { :q => '8 &mdash;  2', :a => 6} ]

    def self.random_select
      DB.sample
    end

end
