import AsyncStorage from '@react-native-async-storage/async-storage';
const KEY = 'stopbet_prefs_v1';

async function readPrefs(){ const r = await AsyncStorage.getItem(KEY); return r?JSON.parse(r):{}; }
async function writePrefs(o){ await AsyncStorage.setItem(KEY, JSON.stringify(o||{})); }

export async function saveRules(rules){ const p = await readPrefs(); p.rules = {...p.rules, ...rules}; await writePrefs(p); }
export async function getRules(){ const p = await readPrefs(); return p.rules || {}; }

export function sanitizeAndFilterText(text){
  if(!text || typeof text !== 'string') return null;
  const low = text.toLowerCase();
  const ads = ['ganhou','winner','jackpot','ganhador','premio','promo','oferta'];
  for(const a of ads) if(low.includes(a)) return null;
  const m = low.replace(/[^\d.,]/g,' ').match(/(\d+[.,]?\d{0,2})/);
  if(!m) return null;
  const v = parseFloat(m[1].replace(',', '.'));
  if(isNaN(v) || v >= 1e6) return null;
  return v;
}

export async function triggerBlock(reason){
  const p = await readPrefs();
  const until = Date.now() + 12*60*60*1000;
  p.block_until = until; p.block_reason = reason;
  await writePrefs(p);
  return until;
}
export async function isBlocked(){
  const p = await readPrefs();
  return !!(p.block_until && p.block_until > Date.now());
}
export default { saveRules, getRules, sanitizeAndFilterText, triggerBlock, isBlocked };
