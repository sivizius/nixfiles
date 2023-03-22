{ debug, intrinsics, number, type, ... }:
{
  add
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          intrinsic.add x y
        else
          debug.panic "add"
          {
            text                        =   "Cannot add ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  and
  =   x:
      y:
        if  bool.isInstanceOf x
        &&  bool.isInstanceOf Y
        then
          x && y
        else
          debug.panic "and"
          {
            text                        =   "Cannot and ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  div
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          intrinsic.div x y
        else
          debug.panic "div"
          {
            text                        =   "Cannot divide ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  equal
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          x == y
        else
          debug.panic "equal"
          {
            text                        =   "Cannot compare ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  lessThan
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          intrinsic.lessThan x y
        else
          debug.panic "lessThan"
          {
            text                        =   "Cannot compare ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  mul
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          intrinsic.sub x y
        else
          debug.panic "mul"
          {
            text                        =   "Cannot multiply ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  neg
  =   x:
        if  number.isInstanceOf x
        then
          0 - x
        else
          debug.panic "neg"
          {
            text                        =   "Cannot negate ${type.get x}:";
            data                        =   { inherit x; };
          };
  not
  =   x:
        if  bool.isInstanceOf x
        then
          !x
        else
          debug.panic "not"
          {
            text                        =   "Cannot not ${type.get x}:";
            data                        =   { inherit x; };
          };
  or
  =   x:
      y:
        if  bool.isInstanceOf x
        &&  bool.isInstanceOf Y
        then
          x || y
        else
          debug.panic "or"
          {
            text                        =   "Cannot or ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
  sub
  =   x:
      y:
        if  number.isInstanceOf x
        &&  number.isInstanceOf Y
        then
          intrinsic.sub x y
        else
          debug.panic "sub"
          {
            text                        =   "Cannot subtract ${type.get x} with ${type.get y}:";
            data                        =   { inherit x y; };
          };
}