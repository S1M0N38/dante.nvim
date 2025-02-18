# Changelog

## [1.3.1](https://github.com/S1M0N38/dante.nvim/compare/v1.3.0...v1.3.1) (2025-01-10)


### Bug Fixes

* update nil checking in callbacks ([7dcbbe9](https://github.com/S1M0N38/dante.nvim/commit/7dcbbe9c3405bea2eddab581d42b9c969b865747))

## [1.3.0](https://github.com/S1M0N38/dante.nvim/compare/v1.2.0...v1.3.0) (2025-01-09)


### Features

* update ai.nvim dependency and improve doc ([5021c1d](https://github.com/S1M0N38/dante.nvim/commit/5021c1d0b878eef29c4505cd59cfb4e9b8a7d09d))

## [1.2.0](https://github.com/S1M0N38/dante.nvim/compare/v1.1.0...v1.2.0) (2024-09-25)


### Features

* add health check module for validating presets and options ([ac3160f](https://github.com/S1M0N38/dante.nvim/commit/ac3160f1e3f773459a0d4dff0ba760ac303af7a4))
* add support for overlay layout and improve folding behavior ([06681d0](https://github.com/S1M0N38/dante.nvim/commit/06681d0401d3051204361a475f0e3eea452d85fc))
* **types:** add RequestTable and ResponseTable classes ([ea75a28](https://github.com/S1M0N38/dante.nvim/commit/ea75a2846bd7ddd4181129a974cdc93fceff7fc1))
* update lua type annotations ([9ff3379](https://github.com/S1M0N38/dante.nvim/commit/9ff337974f74ddd19a7c1dd01ee9da75b1bb871b))

## [1.1.0](https://github.com/S1M0N38/dante.nvim/compare/v1.0.1...v1.1.0) (2024-09-23)


### Features

* add callback and utility functions for chat completion ([fde4cc2](https://github.com/S1M0N38/dante.nvim/commit/fde4cc2605558ea6d538a08c8d0304af9d7b2f8d))
* **ci:** update ci to base.nvim template ([0a69989](https://github.com/S1M0N38/dante.nvim/commit/0a699892eaba75409f972f86344f06b954722801))
* **ci:** update ci to base.nvim template [#17](https://github.com/S1M0N38/dante.nvim/issues/17) ([c6f92aa](https://github.com/S1M0N38/dante.nvim/commit/c6f92aad4919e87e27ce3d76f7b750fc6bf0781e))


### Bug Fixes

* **workflows:** update Lua workspace and add environment variable for tests ([4e8a974](https://github.com/S1M0N38/dante.nvim/commit/4e8a9748d62001ace537bf6faed23601e6b6f310))

## [1.0.1](https://github.com/S1M0N38/dante.nvim/compare/v1.0.0...v1.0.1) (2024-09-04)


### Bug Fixes

* **config:** improve formatting and consistency in assistant instructions ([4b7e8fe](https://github.com/S1M0N38/dante.nvim/commit/4b7e8fe3e2366904352534dc705d5f743c6b7375))

## 1.0.0 (2024-09-04)


### ⚠ BREAKING CHANGES

* use ai.nvim for HTTPS requests
* change option scheme
* drop assistant.lua in favor of ai.nvim

### Features

* add {{NOW}} placeholder to default preset ([2570930](https://github.com/S1M0N38/dante.nvim/commit/257093060e5256050f222240732f52ede629cefd))
* add rockspec to publish on luarocks ([ed3d90e](https://github.com/S1M0N38/dante.nvim/commit/ed3d90e4023846c521a99c902ade6653aa30a4a6))
* add unique buffer name and chunked response handling ([2c3d37a](https://github.com/S1M0N38/dante.nvim/commit/2c3d37a5d14ca47a404c26db83815bdc840ddc72))
* **assistant:** add base_url option ([7ab924b](https://github.com/S1M0N38/dante.nvim/commit/7ab924bb27b5384d0c4bf38e56b22d9c407ad0c5))
* **assistant:** add stream option ([749b486](https://github.com/S1M0N38/dante.nvim/commit/749b486cba481f894a44a6c8a4217641122476ab))
* **assistant:** make auth env var optional ([3e007d1](https://github.com/S1M0N38/dante.nvim/commit/3e007d10433adaa9e72adbf9afb859b930d0d3a1))
* change option scheme ([39c4ecb](https://github.com/S1M0N38/dante.nvim/commit/39c4ecb9998cd0de8a89947f6f153da66128b540))
* **config:** extend preset with global config ([00c1a71](https://github.com/S1M0N38/dante.nvim/commit/00c1a71b5f60d82b56010b1861185123bb03d75e))
* Dante command autocomplete with preset ([196f398](https://github.com/S1M0N38/dante.nvim/commit/196f398c740d4a5543b1805bca91a62461da92e0))
* drop assistant.lua in favor of ai.nvim ([a365764](https://github.com/S1M0N38/dante.nvim/commit/a365764a469fb570543e502230f38da6bc00a871))
* make "default" prompt as default ([d9437ec](https://github.com/S1M0N38/dante.nvim/commit/d9437ec09a0a5bb6975f91169e5182fd03d423e6))
* new usage video and move readme to assets ([17c66f2](https://github.com/S1M0N38/dante.nvim/commit/17c66f2248abc22a2695b0f6bbd1d8f4fc1aa2e4))
* pass preset table instead of preset name ([d13e173](https://github.com/S1M0N38/dante.nvim/commit/d13e17318a174db9bb363a5db8cf46448690a703))
* require range when using :Dante ([7176532](https://github.com/S1M0N38/dante.nvim/commit/7176532ba6c2b6355313541ac87af8422c626420))
* update default config with most recent model ([9a9e741](https://github.com/S1M0N38/dante.nvim/commit/9a9e7415012da0d5d86f1a325df280b58bf0de96))
* use ai.nvim for HTTPS requests ([9715f96](https://github.com/S1M0N38/dante.nvim/commit/9715f9673524e685e5f6e149f425cb49dcd455c8))


### Bug Fixes

* add deps in SETUP section in dante.txt ([64865fb](https://github.com/S1M0N38/dante.nvim/commit/64865fbf18e21ebf4aba6479274ad0bb7957e016))
* format function for placeholder ([4417a0d](https://github.com/S1M0N38/dante.nvim/commit/4417a0dc769226be3df93406d48f6a3b8053db17))
* **readme:** improve english ([5803169](https://github.com/S1M0N38/dante.nvim/commit/580316938fd84f2c2758102a1bda9467a27b64ea))
* remove deprecated nvim functions ([5abf004](https://github.com/S1M0N38/dante.nvim/commit/5abf0045363b04d592f36993e4507b8997d4f094))
* starting line of the query was off by one ([c726a96](https://github.com/S1M0N38/dante.nvim/commit/c726a9699f742cba925dab9cf4551218d0137178))
* typecheck and lint in init.lua ([3bc576a](https://github.com/S1M0N38/dante.nvim/commit/3bc576a6a23bfc4307c097a77713e9ba86aa43dd))
