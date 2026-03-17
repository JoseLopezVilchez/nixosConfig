{
  config,
  pkgs,
  ...
}:
let
  baseDir = "${config.home.homeDirectory}/aiservices";

  qdrantConfig = pkgs.writeText "qdrant.yaml" ''
    storage:
      storage_path: ${baseDir}/qdrant/storage
      snapshots_path: ${baseDir}/qdrant/snapshots
      snapshots_config:
        snapshots_storage: local
      temp_path: ${baseDir}/qdrant/snapshots_temp

    service:
      http_port: 6333
      grpc_port: 6334
  '';
in
{
  home.packages = with pkgs; [
    ollama-vulkan
    qdrant
    nodejs_24
    python315
    n8n
  ];

  systemd.user = {
    targets.ai-services = {
      Unit.Description = "AI Services Group";
      Install.WantedBy = [ "default.target" ];
    };
    services = {
      ollama = {
        Unit = {
          Description = "Ollama Service";
          After = [ "network.target" ];
          PartOf = [ "ai-services.target" ];
        };
        Service = {
          ExecStart = "${pkgs.ollama-vulkan}/bin/ollama serve";
          Restart = "on-failure";
          Environment = "OLLAMA_MODELS=${baseDir}/ollama";
        };
        Install.WantedBy = [ "ai-services.target" ];
      };

      qdrant = {
        Unit = {
          Description = "Qdrant Vector DB";
          PartOf = [ "ai-services.target" ];
        };

        Service = {
          ExecStart = "${pkgs.qdrant}/bin/qdrant --config-path ${qdrantConfig}";
          Restart = "on-failure";
          WorkingDirectory = baseDir;
        };
        Install.WantedBy = [ "ai-services.target" ];
      };

      n8n = {
        Unit = {
          Description = "n8n via bunx";
          PartOf = [ "ai-services.target" ];
        };
        Service = {
          WorkingDirectory = "${baseDir}/n8n";
          ExecStart = "${pkgs.n8n}/bin/n8n";
          Restart = "on-failure";
          Environment = [
            "PATH=${
              pkgs.lib.makeBinPath [
                pkgs.nodejs_24
                pkgs.python315
              ]
            }"
            "N8N_USER_FOLDER=${baseDir}/n8n"
            "N8N_PYTHON_BINARY=${pkgs.python315}/bin/python3"
            "N8N_BLOCK_SVC_REGISTRATION_EMAIL=true"
          ];
        };

        Install.WantedBy = [ "ai-services.target" ];
      };
    };
  };
}
