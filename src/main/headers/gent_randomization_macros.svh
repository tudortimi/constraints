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


`ifndef GENT_RANDOMIZATION_MACROS
`define GENT_RANDOMIZATION_MACROS


`define gent_randomization_utils(TYPE) \
  local static gent_randomization::policy #(TYPE) global_policies[$]; \
  local rand gent_randomization::policy #(TYPE) instance_policies[$]; \
  \
  static function void add_global_constraint(gent_randomization::policy #(TYPE) c); \
    global_policies.push_back(c); \
  endfunction \
  \
  static function void remove_all_global_constraints(); \
    global_policies.delete(); \
  endfunction \
  \
  function void add_instance_constraint(gent_randomization::policy #(TYPE) c); \
    gent_randomization::policy #(TYPE) c_copy = new c; \
    c_copy.set_object(this); \
    instance_policies.push_back(c_copy); \
  endfunction \
  \
  function void remove_all_instance_constraints(); \
    instance_policies.delete(); \
  endfunction \
  \
  function void pre_randomize(); \
    foreach (global_policies[i]) begin \
      add_instance_constraint(global_policies[i]); \
    end \
  endfunction


`endif
