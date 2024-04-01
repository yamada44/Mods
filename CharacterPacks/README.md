# Instructions

Run `bash make.sh`!

File structure:
- ~~`src/`: final compilation destination for each mod~~ NOTE: Due to Warzone limitations, compilation destination will be the original top-level directories
- `CharacterPackTemplate/`: base code files that will be copied to each mod folder
- Anything in `assets/[mod_name]/` will be copied to that folder
- `tests/`: unit tests for CharacterPackTemplate code
- `config.json`: variables for each mod
- `make.sh`: build script to create all mod folders

Steps to add/change a mod:
1. Add mod variables to `config.json`
2. Add images, description, and any other assets in `assets/`
3. Run `bash make.sh`!
