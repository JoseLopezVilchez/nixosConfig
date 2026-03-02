{
  pkgs,
  ...
}:
let
  username = "redfinger";
  homeDir = "/home/${username}";
  baseDir = "${homeDir}/aiservices";

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
  users.users.${username}.packages = with pkgs; [
    ollama-vulkan
    qdrant
    qdrant-web-ui
    n8n
  ];

  systemd = {
    user = {
      targets.ai-services = {
        description = "AI Services Group";
      };
      services = {
        ollama = {
          description = "Ollama Service";
          partOf = [ "ai-services.target" ];
          environment = {
            OLLAMA_MODELS = "${baseDir}/ollama";
          };
          serviceConfig = {
            ExecStart = "${pkgs.ollama-vulkan}/bin/ollama serve";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };

        qdrant = {
          description = "Qdrant Vector DB";
          partOf = [ "ai-services.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.qdrant}/bin/qdrant --config-path ${qdrantConfig}";
            Restart = "on-failure";
            WorkingDirectory = baseDir;
          };
          wantedBy = [ "ai-services.target" ];
        };

        qdrant-web = {
          description = "Qdrant Web UI";
          partOf = [ "ai-services.target" ];
          after = [ "qdrant.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.qdrant-web-ui}/bin/qdrant-web-ui";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };

        n8n = {
          description = "n8n via bunx";
          partOf = [ "ai-services.target" ];
          environment = {
            N8N_USER_FOLDER = "${baseDir}/n8n";
          };
          serviceConfig = {
            WorkingDirectory = "${baseDir}/n8n";
            ExecStart = "${pkgs.n8n}/bin/n8n";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };
      };
    };
  };
}
