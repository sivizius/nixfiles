{ resizeHeight, resizeWidth, up, down, left, right }:
{
  resize
  =   {
        "Return"                        =   "mode \"default\"";
        "Escape"                        =   "mode \"default\"";
        "${up}"                         =   "resize shrink height  ${resizeHeight}";
        "Up"                            =   "resize shrink height  ${resizeHeight}";
        "${left}"                       =   "resize shrink width   ${resizeWidth}";
        "Left"                          =   "resize shrink width   ${resizeWidth}";
        "${down}"                       =   "resize grow   height  ${resizeHeight}";
        "Down"                          =   "resize grow   height  ${resizeHeight}";
        "${right}"                      =   "resize grow   width   ${resizeWidth}";
        "Right"                         =   "resize grow   width   ${resizeWidth}";
      };
}
