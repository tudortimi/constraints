// Copyright 2023 Tudor Timisescu (verificationgentleman.com)
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


/* package private */ class constraints_helper #(type TYPE = int);

  local const TYPE object;

  local static constraints::abstract_constraint #(TYPE) global_constraints[$];
  local rand constraints::abstract_constraint #(TYPE) instance_constraints[$];


  function new(TYPE object);
    this.object = object;
  endfunction


  static function void add_global_constraint(constraints::abstract_constraint #(TYPE) c);
    global_constraints.push_back(c);
  endfunction


  static function void remove_all_global_constraints();
    global_constraints.delete();
  endfunction


  function void add_instance_constraint(constraints::abstract_constraint #(TYPE) c);
    constraints::abstract_constraint #(TYPE) c_copy = new c;
    c_copy.set_object(this.object);
    instance_constraints.push_back(c_copy);
  endfunction


  function void remove_all_instance_constraints();
    instance_constraints.delete();
  endfunction


  function void pre_randomize();
    foreach (global_constraints[i]) begin
      add_instance_constraint(global_constraints[i]);
    end
  endfunction

endclass
