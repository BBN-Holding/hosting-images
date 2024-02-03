import { ServerTypes } from 'bbn-one/spec/music.ts';

export const version_apis: Record<string, [ string, (json: any) => string[] ]> = {
    "vanilla": [ "https://launchermeta.mojang.com/mc/game/version_manifest.json", ({ versions }: { versions: { id: string, type: string, url: string, time: string, releaseTime: string; }[]; }) => versions.map(version => version.id) ], // Snapshots into group as soon as new webgen dropdown inputs are available
    "fabric": [ "https://meta.fabricmc.net/v2/versions/game", (versions: { version: string, stable: boolean; }[]) => versions.map(version => version.version) ],
    "forge": [ "https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json", ({ promos }: { promos: Record<string, string>; }) => Object.entries(promos).map(([ key, value ]) => `${key.replace(/-latest|-recommended/g, '')}-${value}`).reverse() ], // use https://files.minecraftforge.net/net/minecraftforge/forge/maven-metadata.json as soon as new webgen dropdown inputs are available
    "purpur": [ "https://api.purpurmc.org/v2/purpur", ({ versions }: { versions: string[]; }) => versions.reverse() ],
    "bedrock": [ "https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json", ({ linux: { versions } }: { linux: { versions: string[]; }; }) => versions.reverse() ],
    "pocketmine": [ "https://hub.docker.com/v2/repositories/pmmp/pocketmine-mp/tags/?page_size=1000", ({ results }: { results: [ { name: string; } ]; }) => results.map(x => x.name).filter(x => x != "latest").sort().reverse() ]
};

export async function getVersions(type: ServerTypes) {
    const version_api = version_apis[ type ];
    const [ url, filter ] = version_api;
    const verdata = await fetch(url);
    return filter(await verdata.json());
}

// generate purpur