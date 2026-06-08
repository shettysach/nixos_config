# Nix Style Guide For Agents

This guide is written as instructions for an agent editing Nix code. Follow it even when public examples or pretrained habits suggest older idioms such as broad `with pkgs;` scopes or defaulting to `flake-utils`.

## Source Baseline

Use these sources as the authority behind this guide:

| Topic | Source |
| --- | --- |
| General best practices | https://nix.dev/guides/best-practices.html |
| Language scoping and `with` | https://nix.dev/manual/nix/2.24/language/scope |
| Language basics | https://nix.dev/tutorials/nix-language.html |
| Flakes concept | https://nix.dev/concepts/flakes.html |
| `flake-utils` status | https://wiki.nixos.org/wiki/Flake_Utils |
| `flake-parts` alternative | https://wiki.nixos.org/wiki/Flake_Parts |
| NixOS module system | https://nixos.org/nixos/manual/index.html |
| NixOS module arguments | https://nixos.org/nixos/manual/options.html#opt-_module.args |
| Nixpkgs overlays | https://nixos.org/manual/nixpkgs/stable/#chap-overlays |
| Nixpkgs unfree policy | https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree |
| `callPackage` and overrides | https://nix.dev/tutorials/callpackage.html |

## Decision Policy

| Priority | Rule |
| --- | --- |
| 1 | Prefer clarity and auditability over short clever Nix. |
| 2 | Prefer explicit data flow over ambient scope. |
| 3 | Prefer module options over custom plumbing. |
| 4 | Prefer pinned, declared inputs over environment-dependent inputs. |
| 5 | Prefer local, narrow changes over global overlays or global arguments. |
| 6 | Prefer boring Nix idioms that survive refactors. |

## Quick Rules

| Rule | Requirement |
| --- | --- |
| `with` | Do not introduce broad `with pkgs;` scopes. Avoid `with` entirely unless the scope is tiny and conventional, such as `with lib;` inside a short expression. |
| Package lists | Use `lib.attrValues { inherit (pkgs) foo bar; }` when order does not matter. Use explicit lists when order matters. |
| `flake-utils` | Do not add `flake-utils` to new flakes. Use explicit `lib.genAttrs` or `flake-parts` when a framework is justified. |
| `<nixpkgs>` | Do not use lookup paths in real config. Use flake inputs, pins, or explicit imports. |
| `rec` | Avoid `rec` by default. Use `let` bindings or explicit self-naming. |
| `specialArgs` | Keep `specialArgs` narrow. Use it mainly for values needed during `imports` resolution. |
| `inputs` | Do not pass all flake inputs to every module unless the repo intentionally uses that architecture. Pass named values. |
| Nixpkgs imports | When importing Nixpkgs manually, set `system`, `config`, and `overlays` explicitly. |
| Unfree packages | Prefer `allowUnfreePredicate` over broad `allowUnfree = true` unless broad allowance is an explicit policy. |
| Overlays | Use overlays for package-set-wide changes, not one-off package tweaks. |
| Overrides | Use `.override` for function/package arguments; use `.overrideAttrs` for derivation attributes. Avoid `overrideDerivation`. |
| Optional list items | Use `lib.optionals` only when the existing option already has a safe boolean condition. Do not restructure modules into conditional `config` blocks by default. |
| Module defaults | Use `mkDefault`, `mkForce`, `mkBefore`, and `mkAfter` only when priority or ordering is intentional. |
| Formatting | Use the repo's formatter. If none exists, use `alejandra` for Nix files. |
| Validation | Prefer `nix flake check`, `nixos-rebuild build --flake`, `home-manager build --flake`, `statix`, and `deadnix` when available. |

## Language Style

### 1. Avoid Broad `with`

**Rule:** Do not write this in new code:

```nix
environment.systemPackages = with pkgs; [
  ripgrep
  fd
  jq
];
```

**Preferred when order does not matter:**

```nix
environment.systemPackages = lib.attrValues {
  inherit (pkgs) ripgrep fd jq;
};
```

**Preferred when order matters:**

```nix
environment.systemPackages = [
  pkgs.ripgrep
  pkgs.fd
  pkgs.jq
];
```

**Why:**

- `with` introduces implicit names into scope.
- The Nix manual documents multiple scopes and shadowing rules.
- nix.dev says static analysis cannot reason well about broad `with`.
- Multiple `with` expressions make origin tracking difficult.

**Allowed exceptions:**

- Very small local expressions where source ambiguity is impossible.
- Legacy code that is not being meaningfully edited.
- Nixpkgs conventions in upstream package recipes, when matching nearby style matters more than local preference.

### 2. Understand `attrValues`

**Rule:** Use `lib.attrValues` only when list order is irrelevant.

**Good uses:**

```nix
home.packages = lib.attrValues {
  inherit (pkgs) obsidian mpv imv;
};
```

```nix
fonts.packages = lib.attrValues {
  inherit (pkgs) lora work-sans;
  inherit (pkgs.nerd-fonts) jetbrains-mono;
};
```

**Avoid when order matters:**

```nix
boot.kernelParams = [
  "first"
  "second"
];
```

**Footguns:**

- Attribute names are unique; duplicate keys are errors or get hidden through composition.
- Values are returned in attribute-name order, not source order.
- Names used for keys become part of readability; choose stable, obvious keys for non-`inherit` values.

### 3. Avoid `rec`

**Rule:** Prefer `let` over `rec`.

**Avoid:**

```nix
rec {
  pname = "tool";
  name = "${pname}-${version}";
  version = "1.0.0";
}
```

**Prefer:**

```nix
let
  pname = "tool";
  version = "1.0.0";
in {
  inherit pname version;
  name = "${pname}-${version}";
}
```

**Why:**

- nix.dev warns that `rec` can create hard-to-debug infinite recursion when shadowing names.
- `let` makes dependency direction clearer.

**Allowed exception:**

- Small attrsets where Nixpkgs conventions expect `rec`, and the names are not likely to shadow outer scope.

### 4. Quote URLs

**Rule:** Always quote URLs.

**Avoid:**

```nix
homepage = https://example.com;
```

**Prefer:**

```nix
homepage = "https://example.com";
```

**Why:**

- nix.dev recommends quoted URLs.
- Bare URL syntax is legacy convenience and is easier to misread.

### 5. Avoid `<...>` Lookup Paths

**Rule:** Do not use `<nixpkgs>` or other lookup paths in committed config.

**Avoid:**

```nix
let
  pkgs = import <nixpkgs> {};
in
pkgs.hello
```

**Prefer in flakes:**

```nix
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
pkgs.hello
```

**Prefer outside flakes:**

```nix
let
  pkgs = import sources.nixpkgs {
    system = "x86_64-linux";
    config = {};
    overlays = [];
  };
in
pkgs.hello
```

**Why:**

- Lookup paths depend on `NIX_PATH`, which is external mutable state.
- The same expression can evaluate differently across machines.

### 6. Be Explicit When Importing Nixpkgs

**Rule:** When manually importing Nixpkgs, specify the import policy.

**Prefer:**

```nix
pkgs = import nixpkgs {
  inherit system;
  config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "vscode"
      ];
  };
  overlays = [];
};
```

**Why:**

- nix.dev documents that Nixpkgs can otherwise read configuration from external files.
- Explicit `config` and `overlays` make evaluation reproducible.

## Flake Style

### 7. Do Not Add `flake-utils` By Default

**Rule:** Do not introduce `flake-utils` in new code.

**Preferred for one or two systems:**

```nix
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  devShells.${system}.default = pkgs.mkShell {
    packages = [
      pkgs.nixd
      pkgs.statix
    ];
  };
}
```

**Preferred for several systems without a framework:**

```nix
let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  forAllSystems = nixpkgs.lib.genAttrs systems;
in {
  devShells = forAllSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [ pkgs.nixd ];
      };
    });
}
```

**Use `flake-parts` when:**

- The flake has many `packages`, `checks`, `devShells`, overlays, or NixOS modules.
- Per-system and system-independent outputs are getting tangled.
- You want module-system structure for the flake itself.

**Why:**

- The Official NixOS Wiki warns that `flake-utils` is not recommended.
- The official `flake-parts` page describes it as the preferred framework alternative.
- For a single-machine config, a framework usually hides more than it helps.

### 8. Keep Supported Systems Visible

**Rule:** The supported systems list must be visible in the flake.

**Avoid:**

```nix
flake-utils.lib.eachDefaultSystem (system: ...)
```

**Prefer:**

```nix
systems = [
  "x86_64-linux"
  "aarch64-linux"
];
```

**Why:**

- Hidden default system lists create surprise support claims.
- Adding or removing platforms should be a visible review event.

### 9. Use `follows` Deliberately

**Rule:** Add `inputs.foo.inputs.nixpkgs.follows = "nixpkgs";` when the input supports it and should share the repo's Nixpkgs.

**Prefer:**

```nix
inputs.home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

**Check before applying:**

- Does the upstream flake expose a `nixpkgs` input?
- Does it expect its own pinned Nixpkgs for compatibility?
- Are you consuming modules, overlays, or only packages?

**Why:**

- Too many independent Nixpkgs instances increase evaluation cost and closure mismatch risk.
- Blindly forcing `follows` can break inputs that depend on a specific revision.

### 10. Keep Flake Outputs Boring

**Rule:** A flake should expose standard outputs with predictable names.

**Prefer:**

```nix
{
  nixosConfigurations.hostname = ...;
  homeConfigurations."user@hostname" = ...;
  devShells.${system}.default = ...;
  formatter.${system} = pkgs.alejandra;
}
```

**Avoid:**

- Deeply nested custom output namespaces unless a consumer requires them.
- Letting `outputs` become a large unstructured program.
- Hiding host/user names behind unnecessary abstraction in a one-machine repo.

## Module Style

### 11. Keep `specialArgs` Narrow

**Rule:** Use `specialArgs` for values needed during import resolution. Use normal module options or `_module.args` for ordinary plumbing.

**Avoid:**

```nix
specialArgs = inputs;
```

**Better:**

```nix
specialArgs = {
  inherit system;
  niriModule = inputs.niri.nixosModules.niri;
};
```

**Why:**

- The NixOS manual says `_module.args` should be used for most arguments.
- `imports` must be computed statically before normal option evaluation.
- Passing all `inputs` gives every module ambient access to everything.

### 12. Prefer Options Over Arguments For Repo Policy

**Rule:** If a value is part of system policy, expose it as a module option or a normal config value instead of a hidden function argument.

**Prefer:**

```nix
{ lib, ... }: {
  options.local.desktop.browser = lib.mkOption {
    type = lib.types.str;
    default = "firefox";
    description = "Default graphical browser package attribute name.";
  };
}
```

**Use arguments for:**

- Package handles.
- Flake inputs needed for imports.
- Rare non-option values that cannot reasonably be represented as config.

### 13. Use Priorities Intentionally

**Rule:** Only use priority/order helpers when there is an actual merge conflict or ordering requirement.

| Helper | Use |
| --- | --- |
| `lib.mkDefault` | Provide a weak default another module may override. |
| `lib.mkForce` | Deliberately override competing definitions. Use sparingly. |
| `lib.mkBefore` | Put list items before other definitions. |
| `lib.mkAfter` | Put list items after other definitions. |
| `lib.mkMerge` | Return several logical groups of definitions from one module. Use only when it keeps an existing module clearer. |

**Avoid:**

- Using `mkForce` as a routine fix.
- Using list ordering helpers on options where order has no meaning.

### 14. Keep Imports Static And Boring

**Rule:** Keep `imports` simple, static, and near the top of the module.

**Prefer:**

```nix
{
  imports = [
    ./hardware.nix
    ./desktop.nix
  ];
}
```

**Avoid:**

```nix
{
  imports =
    if config.local.desktop.enable
    then [ ./desktop.nix ]
    else [];
}
```

**Why:**

- The NixOS manual documents that `imports` must be resolved before normal option values.
- Do not turn commented imports into conditional module logic unless that refactor is explicitly requested and tested.

## Package And Overlay Style

### 15. Prefer `callPackage` For Local Packages

**Rule:** Write local package recipes as functions and instantiate them with `pkgs.callPackage`.

**Package file:**

```nix
{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "example";
  version = "1.0.0";
  src = fetchFromGitHub { ... };
  meta = {
    description = "Example package";
    license = lib.licenses.mit;
  };
}
```

**Caller:**

```nix
myPackage = pkgs.callPackage ./pkgs/example.nix {};
```

**Why:**

- `callPackage` is a central Nixpkgs convention.
- It makes dependencies explicit while avoiding repetitive argument wiring.
- It enables `.override`.

### 16. Choose The Smallest Override Mechanism

| Need | Use |
| --- | --- |
| Change a package function argument | `pkg.override { ... }` |
| Change derivation attrs like `src`, `patches`, `buildInputs` | `pkg.overrideAttrs (finalAttrs: previousAttrs: { ... })` |
| Change a package everywhere in a package set | Overlay |
| Patch a module option | NixOS/Home Manager option override |

**Avoid:**

- `overrideDerivation` unless there is no better option.
- Overlays for one package used in one place.
- Re-importing Nixpkgs to get one patched package.

### 17. Use Overlays Sparingly

**Rule:** Use overlays only when the package-set fixed point needs to change.

**Good overlay use:**

```nix
final: prev: {
  myTool = final.callPackage ./pkgs/my-tool {};
}
```

**Good override use instead of overlay:**

```nix
myFirefox = pkgs.firefox.override {
  cfg = {};
};
```

**Why:**

- Nixpkgs overlays compose package sets through a fixed point.
- Overlay order matters.
- Overlays are global within a package set and can have non-local effects.

### 18. Respect `final` And `prev`

**Rule:** In overlays, use `prev` to refer to the package being overridden and `final` for dependencies that should include overlay changes.

**Pattern:**

```nix
final: prev: {
  foo = prev.foo.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      final.bar
    ];
  });
}
```

**Avoid:**

- Using `final.foo` while defining `foo`, unless you intentionally need recursion.
- Pulling dependencies from an unrelated `pkgs`.

## Reproducibility Style

### 19. Pin Inputs

**Rule:** Real config must use pinned inputs.

**Preferred:**

- Flakes with `flake.lock`.
- `npins`, `niv`, or fixed source fetchers outside flakes.
- Fixed-output fetchers with hashes for remote sources.

**Avoid:**

- Floating branches in non-flake imports without lock files.
- `builtins.fetchTarball` without a hash.
- Fetching from shell scripts at build time.

### 20. Name Source Paths

**Rule:** For derivation sources using local paths, use a stable name when path naming affects output.

**Prefer:**

```nix
src = builtins.path {
  path = ./.;
  name = "my-project-source";
};
```

**Why:**

- nix.dev notes that `src = ./.;` can include the parent directory name in the store path.
- Different checkout directory names can cause needless rebuilds.

### 21. Keep Flake Source State Clean

**Rule:** Before judging Nix behavior, check Git state.

**Commands:**

```sh
git status --short
nix flake metadata
```

**Watch for:**

- Untracked config files not included in flake evaluation.
- Dirty tree warnings.
- Generated files accidentally copied into the Nix store.
- Large assets included through broad `src = ./.;`.

## NixOS And Home Manager Style

### 22. Separate System And User Ownership

| Put here | Examples |
| --- | --- |
| `environment.systemPackages` | admin tools, system diagnostics, shells, system-wide CLIs |
| `home.packages` | browsers, editors, media apps, chat apps, user-only CLIs |
| NixOS modules | services, users, boot, hardware, networking, security |
| Home Manager modules | user dotfiles, user services, desktop app settings |

**Rule:** If a package is only for one user, prefer Home Manager.

### 23. Do Not Bump State Versions Casually

**Rule:** Treat these as migration compatibility pins:

```nix
system.stateVersion = "24.05";
home.stateVersion = "24.05";
```

**Do not:**

- Update them just because NixOS was upgraded.
- Auto-bump them during refactors.

**Do:**

- Change only after reading release notes for affected defaults.
- Keep a comment if a future-looking value is intentional.

### 24. Prefer Structured Options Over Text Files

**Rule:** If a module exposes typed `settings`, use it before raw file text.

**Prefer:**

```nix
programs.git = {
  enable = true;
  userName = "Name";
  userEmail = "name@example.com";
};
```

**Use raw text when:**

- No module exists.
- The format is unsupported.
- Exact byte-for-byte config is required.

## Formatting And Organization

### 25. File Shape

**Preferred module shape:**

```nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  packages = lib.attrValues {
    inherit (pkgs) example;
  };
in {
  imports = [
    ./other.nix
  ];

  options.local.feature.enable = lib.mkEnableOption "feature";

  config.environment.systemPackages = packages;
}
```

**Rules:**

- Put function arguments first.
- Put `let` bindings before the returned attrset.
- Put `imports` near the top.
- Put `options` before `config` in reusable modules.
- Keep host-specific hardware in host modules.
- Keep package lists grouped by ownership, not aesthetics.

### 26. Naming

| Thing | Style |
| --- | --- |
| Local option namespace | `local.*` or repo-specific prefix |
| Module files | kebab-case or existing repo convention |
| Host configs | hostname as flake output key |
| Home configs | `user@hostname` when multiple homes may exist |
| Package attrs | upstream package name where possible |

### 27. Comments

**Rule:** Comments explain why, not what.

**Good:**

```nix
# Required because this device changes HID instance suffixes across boots.
```

**Avoid:**

```nix
# Enable git.
programs.git.enable = true;
```

## Validation Checklist

Run the checks that match the edit:

| Change | Check |
| --- | --- |
| Any Nix edit | `alejandra --check .` or repo formatter |
| Flake output edit | `nix flake check` |
| NixOS module edit | `nixos-rebuild build --flake .#<host>` |
| Home Manager edit | `home-manager build --flake .#<user@host>` |
| Package expression | `nix build .#<package>` |
| Dev shell | `nix develop .#<shell>` |
| Lint | `statix check` |
| Dead code | `deadnix` |

If a check cannot run because the environment lacks network, permissions, or binary cache access, state that clearly.

## Agent Editing Protocol

1. Read nearby code before editing.
2. Preserve existing repo conventions unless they conflict with this guide.
3. Do not introduce broad `with`, `flake-utils`, `<nixpkgs>`, broad `allowUnfree`, or global overlays casually.
4. Prefer explicit `pkgs.foo` or `lib.attrValues` package lists.
5. Keep `specialArgs` and `extraSpecialArgs` narrow.
6. Do not introduce new module toggle mechanisms unless explicitly requested and tested.
7. Avoid unrelated formatting churn in dirty worktrees.
8. Validate with the smallest meaningful command.
9. Report checks run and checks skipped.

## Review Checklist

Use this when reviewing Nix code:

- Are package origins obvious?
- Is any `with` scope broad enough to hide mistakes?
- Is any list using `attrValues` where order matters?
- Are flake-supported systems visible?
- Was `flake-utils` added unnecessarily?
- Are all Nixpkgs instances intentional?
- Are `follows` declarations present where appropriate?
- Are imports static?
- Is `specialArgs` used only where justified?
- Were commented toggles left alone unless the task explicitly requested a safer option design?
- Is unfree policy centralized and intentional?
- Are overlays necessary, or would `.override`/`.overrideAttrs` be smaller?
- Are state versions left unchanged unless migration is intended?
- Are local source paths named when reproducibility matters?
- Were formatting and evaluation checks run?
