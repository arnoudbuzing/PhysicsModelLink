# RapierVersion

`RapierVersion[]` returns the version string of the linked `rapier3d` Rust crate.

## Usage

```wolfram
RapierVersion[]
```
- Returns a string representing the current version of the underlying Rust library (e.g., `"0.23.0"`).

## Details and Notes

- This function is useful for verifying that the Rust library has been correctly loaded and for identifying the version of the physics engine being used.
- The version string typically corresponds to the version of the `rapier3d` crate used during compilation.

## Examples

### Basic Example
Check the current version of the Rapier engine:
```wolfram
Needs["PhysicsModelLink`"]
RapierVersion[]
(* "0.23.0" *)
```
