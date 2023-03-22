{
  # set backup
  enable
  =   Option.Bool' false
      ''
        the creation of backups when saving a file by adding a tilde (~) to the file’s name.
      '';

  # set allow_insecure_backup
  allowInsecure
  =   Option.Bool' false
      ''
        When backing up files, allow the backup to succeed even if its permissions cannot be (re)set
          due to special OS considerations.
        You should NOT enable this option unless you are sure you need it.
      '';

  # set backupdir <directory>
  directory
  =   Option.String' ""
      {
        example                         =   "$HOME/.nanobackups";
        description
        =   ''
              Make and keep not just one backup file,
                but make and keep a uniquely numbered one every time a file is saved,
                  when backups are enabled with <option>backup</option> or <command>−−backup</command>
                  or <command>−B</command>.
              The uniquely numbered files are stored in the specified directory.
            '';
      };
}
