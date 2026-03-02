{
  pkgs,
  ...
}:
let
  username = "redfinger";
  homeDir = "/home/${username}";
  baseDir = "${homeDir}/aiservices";
in
{
  users.users.${username}.packages = with pkgs; [
    ollama-vulkan
    bun
    qdrant
    qdrant-web-ui
    n8n
  ];

  systemd = {
    user = {
      targets.ai-services = {
        Unit = {
          Description = "AI Services Group";
        };
      };
      services = {
        ollama = {
          Unit = {
            Description = "Ollama Service";
            PartOf = [ "ai-services.target" ];
          };
          Service = {
            ExecStart = "${pkgs.ollama}/bin/ollama serve";
            Environment = "OLLAMA_MODELS=${baseDir}/ollama";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };

        qdrant = {
          Unit = {
            Description = "Qdrant Vector DB";
            PartOf = [ "ai-services.target" ];
          };
          Service = {
            ExecStart = "${pkgs.qdrant}/bin/qdrant --storage-path ${baseDir}/qdrant";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };

        qdrant-web = {
          Unit = {
            Description = "Qdrant Web UI";
            PartOf = [ "ai-services.target" ];
            After = [ "qdrant.service" ];
          };
          Service = {
            ExecStart = "${pkgs.qdrant-web-ui}/bin/qdrant-web-ui";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };

        n8n = {
          Unit = {
            Description = "n8n via bunx";
            PartOf = [ "ai-services.target" ];
          };
          Service = {
            WorkingDirectory = "${baseDir}/n8n";
            ExecStart = "${pkgs.bun}/bin/bun n8n";
            Environment = "N8N_USER_FOLDER=${baseDir}/n8n";
            Restart = "on-failure";
          };
          wantedBy = [ "ai-services.target" ];
        };
      };
    };
  };
}
