{
  boot = {
    enableContainers = true;
    devShmSize = "64m";
    devSize = "64m";
    runSize = "64m";
    tmp = {
      #cleanOnBoot = true;
      tmpfsSize = "69%";
      useTmpfs = true;
    };
  };
  #security.wrapperDirSize = "64m";
}
