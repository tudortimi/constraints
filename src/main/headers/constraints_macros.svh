// Copyright 2018-2023 Tudor Timisescu (verificationgentleman.com)
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


`ifndef CONSTRAINTS_MACROS
`define CONSTRAINTS_MACROS


`define constraints_utils(TYPE) \
  local rand constraints::constraints_helper #(TYPE) __constraints_helper = new(this); \
  \
  static function void add_global_constraint(constraints::abstract_constraint #(TYPE) c); \
    constraints::constraints_helper #(TYPE)::add_global_constraint(c); \
  endfunction \
  \
  static function void remove_all_global_constraints(); \
    constraints::constraints_helper #(TYPE)::remove_all_global_constraints(); \
  endfunction \
  \
  function void add_instance_constraint(constraints::abstract_constraint #(TYPE) c); \
    __constraints_helper.add_instance_constraint(c); \
  endfunction \
  \
  function void remove_all_instance_constraints(); \
    __constraints_helper.remove_all_instance_constraints(); \
  endfunction


`endif
