// Copyright 2018-2022 Tudor Timisescu (verificationgentleman.com)
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

  `include "constraints_macros.svh"


  // An 'item' class defined in a separate package
  class item;
    rand int val;
  endclass


  // A reusable constraint
  class only_even_values extends constraints::abstract_constraint #(item);
    constraint c {
      object.val % 2 == 0;
    }
  endclass


  // Class that adds constraint infrastructure to 'item'
  class constrained_item extends item;
    `constraints_utils(item)
  endclass


  initial begin
    automatic constrained_item i = new();
    automatic only_even_values only_even_vals = new();
    constrained_item::add_global_constraint(only_even_vals);

    repeat (100) begin
      if (!i.randomize())
        $fatal(0, "Randomization failure");
      if (i.val % 2 == 1)
        $fatal(0, $sformatf("Unexpected 'val' seen: %0d", i.val));
    end
  end


  initial begin
    automatic int unsigned num_odd;
    automatic constrained_item i = new();
    automatic only_even_values only_even_vals = new();
    constrained_item::add_global_constraint(only_even_vals);
    constrained_item::remove_all_global_constraints();

    repeat (100) begin
      if (!i.randomize())
        $fatal(0, "Randomization failure");
      if (i.val % 2 == 1)
        num_odd++;
    end
    if (num_odd == 0)
      $fatal(0, "Havent't seen any odd vals");
  end


  class only_zero extends constraints::abstract_constraint #(item);
    constraint c {
      object.val == 0;
    }
  endclass

  initial begin
    automatic constrained_item i = new();
    automatic only_zero only_0 = new();
    i.add_instance_constraint(only_0);

    repeat (100) begin
      if (!i.randomize())
        $fatal(0, "Randomization failure");
      if (i.val != 0)
        $fatal(0, $sformatf("Unexpected 'val' seen: %0d", i.val));
    end
  end


  initial begin
    automatic int unsigned num_non_zero;
    automatic constrained_item i = new();
    automatic only_zero only_0 = new();
    i.add_instance_constraint(only_0);
    i.remove_all_instance_constraints();

    repeat (100) begin
      if (!i.randomize())
        $fatal(0, "Randomization failure");
      if (i.val != 0)
        num_non_zero++;
    end
    if (num_non_zero == 0)
      $fatal(0, "Havent't seen any non-zero vals");
  end



  class bigger_item;

    rand constrained_item i0;
    rand constrained_item i1;


    function new();
      i0 = new();
      i1 = new();
    endfunction

  endclass


  initial begin
    automatic bigger_item it = new();
    automatic only_zero only_0 = new();
    constrained_item::add_global_constraint(only_0);

    repeat (100) begin
      if (!it.randomize())
        $fatal(0, "Randomization failure");
      if (it.i0.val != 0)
        $fatal(0, $sformatf("Unexpected 'val' seen for i0: %0d", it.i0.val));
      if (it.i1.val != 0)
        $fatal(0, $sformatf("Unexpected 'val' seen for i0: %0d", it.i1.val));
    end
  end


  initial begin
    automatic bigger_item it = new();
    automatic only_zero only_0 = new();
    it.i0.add_instance_constraint(only_0);
    it.i1.add_instance_constraint(only_0);
    constrained_item::remove_all_global_constraints();


    repeat (100) begin
      if (!it.randomize())
        $fatal(0, "Randomization failure");
      if (it.i0.val != 0)
        $fatal(0, $sformatf("Unexpected 'val' seen for i0: %0d", it.i0.val));
      if (it.i1.val != 0)
        $fatal(0, $sformatf("Unexpected 'val' seen for i0: %0d", it.i1.val));
    end
  end


  class array_of_items;

    static const int unsigned MAX_NUM_ITEMS = 10;

    rand item items[];

    constraint legal_number_of_items {
      items.size() < MAX_NUM_ITEMS;
    }

    function void pre_randomize();
      items = new[MAX_NUM_ITEMS];
      foreach (items[i])
        items[i] = new();
    endfunction

  endclass


  class constrainable_array_of_items extends array_of_items;

    `constraints_utils(array_of_items)

  endclass


  class all_items_equal_to_five extends constraints::abstract_constraint #(array_of_items);

    constraint c {
      foreach (object.items[i])
        object.items[i].val == 5;
    }

  endclass


  initial begin
    automatic constrainable_array_of_items array = new();
    automatic all_items_equal_to_five all_items_equal_to_5 = new();
    array.add_instance_constraint(all_items_equal_to_5);

    repeat (100) begin
      if (!array.randomize())
        $fatal(0, "Randomization failure");
      foreach (array.items[i])
        if (array.items[i].val != 5)
          $fatal(0, $sformatf("Unexpected 'val' seen for item %0d: %0d", i, array.items[i].val));
    end
  end

endmodule
