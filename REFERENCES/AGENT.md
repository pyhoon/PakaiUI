# Agent guidance for PakaiUI

## B4J builds

Build B4J projects with the installed command-line builder:

```powershell
& 'C:\Program Files\B4X\B4J\B4JBuilder.exe' -Task=Build -NoClean=True -ShowWarnings=True
```

Run it with the project folder as the process working directory (the coding harness's `workdir`); omit `-BaseFolder`. The upstream command-line compilation thread documents `-BaseFolder` as having an open issue. If the folder contains exactly one `.b4j` file, omit `-Project` and let the builder select it.

Running `B4JBuilder.exe` with no arguments prints its own supported parameter list. The installed v10.70 builder reports:

- `-Task=Build` (default; similar to Release compilation) or `-Task=BuildLibrary` (library compilation)
- `-BaseFolder`, `-Project`, `-Obfuscate`, `-ShowWarnings`, `-Configuration`, `-NoClean`, and `-Output`

Use `-NoClean=True` when a project has user-managed runtime files under `Objects/` (including SQLite databases and local configuration). Do not delete or overwrite those files as part of a build. Preserve the full builder output and exit status; do not report a build as successful unless the process exits successfully.

The `java` on `PATH` in this environment is Java 8, which cannot load the Java 19 class files produced by the builder. Launch compiled jars with the installed Java 19 runtime, for example `C:\Java\jdk-19.0.2\bin\java.exe -jar Objects\result.jar`, or use the B4J IDE's Run command.

Builder/API reference: [B4ABuilder / B4JBuilder command-line compilation](https://www.b4x.com/android/forum/threads/b4abuilder-b4jbuilder-command-line-compilation.50154/).

The command-line builder does not print the B4J IDE's warnings, even with `-ShowWarnings=True` (a deliberately bad Object comparison still builds silently). Treat IDE warning numbers as guidance to audit by pattern, not as something the CLI verifies.

## B4J coding conventions

- B4J warning #35: put the `Object`-returning expression on the right side of a comparison so B4J compares by value. Write `If 1 = Column.Get("notnull") Then`, `If False = KeyResult.Get("ok") Then`, `If 0 < Column.Get("pk") Then`, and `If ColumnName = Column.Get("name") Then`; do not write the reversed forms. Apply the same rule to any variable or function result typed `As Object`.
- Never leave a `Catch` block empty. Log `LastException.Message` (or deliberately set a safe fallback value), including cleanup helpers such as `CloseQuietly` and defensive `Db.Close` calls.

## Dependencies

The builder resolves `#AdditionalJar` names from `C:\Program Files\B4X\B4J\libraries`. Ensure project `libs.json` dependencies are installed there before treating a missing-JAR build failure as a source error. Keep dependency versions consistent between `libs.json` and `#AdditionalJar` declarations.