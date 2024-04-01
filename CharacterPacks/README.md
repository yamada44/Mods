# Instructions

Run `bash make.sh`!

File structure:
- `src/`: final compilation destination for each mod
- `CharacterPackTemplate/`: base code files that will be copied to each mod folder
- Anything in `assets/[mod_name]/` will be copied to that folder
- `tests/`: unit tests for CharacterPackTemplate code
- `config.json`: variables for each mod
- `make.sh`: build script to create all mod folders
