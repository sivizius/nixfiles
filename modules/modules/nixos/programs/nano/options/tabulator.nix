{
  size
  =   Option.UnsignedInteger' 0
      {
        example                         =   4;
        description
        =   ''
              Use a tab size of number columns.
              The value of number must be greater than 0.
              The default value is 8.
            '';
      };
  toSpaces
  =   Option.Bool' false
      ''
        Convert typed tabs to spaces.
      '';
}