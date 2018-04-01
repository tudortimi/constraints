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


`ifndef GENT_CONSTRAINTS_MACROS
`define GENT_CONSTRAINTS_MACROS


`define gent_constraints_utils(TYPE) \
  local static gent_constraints::policy #(TYPE) global_policies[$]; \
  local rand gent_constraints::policy #(TYPE) instance_policies[$]; \
  \
  static function void add_global_constraint(gent_constraints::policy #(TYPE) c); \
    global_policies.push_back(c); \
  endfunction \
  \
  function void add_instance_constraint(gent_constraints::policy #(TYPE) c); \
    instance_policies.push_back(c); \
    c.set_object(this); \
  endfunction \
  \
  function void pre_randomize(); \
    foreach (global_policies[i]) begin \
      gent_constraints::policy #(TYPE) c = new global_policies[i]; \
      add_instance_constraint(c); \
    end \
  endfunction


`endif
