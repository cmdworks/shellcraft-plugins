# --- docker compatibility (plugin: docker) ---
if not command -q docker; and command -q podman
    function docker; podman $argv; end
end
if command -q docker; or command -q podman
    function d; docker $argv; end
    function dc; docker compose $argv; end
    function dps; docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" $argv; end
    function dsh
        set -l c (docker ps --format '{{.Names}}' | command shellcraft pick); or return
        docker exec -it $c sh -c 'command -v bash >/dev/null && exec bash || exec sh'
    end
    function dlogs
        set -l c (docker ps -a --format '{{.Names}}' | command shellcraft pick); or return
        docker logs -f --tail 100 $c
    end
end
