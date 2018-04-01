// Copyright 2018 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


module test;

  `include "gent_constraints_macros.svh"


  // An 'item' class defined in a separate package
  class item;
    rand int val;
  endclass


  // A reusable constraint
  class only_even_values extends gent_constraints::policy #(item);
    constraint c {
      object.val % 2 == 0;
    }
  endclass


  // Class that adds constraint infrastructure to 'item'
  class constrained_item extends item;
    `gent_constraints_utils(item)
  endclass


  initial begin
    automatic constrained_item i = new();
    automatic only_even_values only_even_vals = new();

    constrained_item::add_global_constraint(only_even_vals);
    repeat (100) begin
      if (!i.randomize())
        $fatal(0, "Randomization failure");
      if (i.val % 2 == 1)
        $fatal(0, $sformatf("Unexpected 'val' seen", i.val));
    end
  end

endmodule
