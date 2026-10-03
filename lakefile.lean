import Lake
open Lake DSL

package «tokenUnits» where
  -- add package configuration options here

lean_lib «TokenUnits» where
  -- add library configuration options here

@[default_target]
lean_exe «tokenUnits» where
  root := `Main
