{ error, type, ... } @ core:
  type "never"
  {
    isInstanceOf                        =   x: false;
    #never                               =   error.panic "Cannot assign the bottom type to anything!";
  }