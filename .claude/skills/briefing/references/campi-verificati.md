# Campi verificati con ads_get_field_context

I nomi dei campi del connettore Meta Ads sono gli stessi per tutti gli account: valgono per ogni profilo. Usa il nome della prima colonna nelle chiamate e quello della seconda nelle tabelle per il cliente. Se verifichi un campo nuovo, aggiungilo qui con la data; se il connettore cambia comportamento, correggi la riga.

Verificati il 2026-10-26.

| Campo | Nome da mostrare | Livelli | Note |
|---|---|---|---|
| name | name | tutti | filtrabile, ordinabile |
| objective | objective | campaign, ad | enum (OUTCOME_LEADS, OUTCOME_SALES, …) |
| effective_status | effective status | campaign, adset, ad | |
| amount_spent | amount spent | tutti | alias `spend` |
| results | results | tutti | a livello account può non essere disponibile |
| cost_per_result | cost per result | campaign, adset, ad | non a livello account |
| daily_budget | daily budget | campaign, adset | non ordinabile |
| lifetime_budget | lifetime budget | campaign, adset | |
| lead | Leads | tutti | alias `leads` |
| link_click | link clicks | tutti | |
| frequency | frequency | tutti | |
| ctr | CTR (all) | tutti | |
| impressions | Impressions | tutti | |

Verificati il 2026-11-19 (campagne di notorietà e video).

| Campo | Nome da mostrare | Livelli | Note |
|---|---|---|---|
| reach | Reach | tutti | persone diverse raggiunte |
| cpp | Cost per 1,000 Meta Accounts reached | tutti | costo ogni 1.000 persone raggiunte |
| cpm | CPM (cost per 1,000 impressions) | tutti | |
| media_views | Views | tutti | |
| video_play_actions | Video plays | tutti | il video è partito: denominatore di aggancio e tenuta |
| video_continuous_2_sec_watched_actions | 2-second continuous video plays | tutti | |
| 3_second_video_plays | 3-second video plays | account, campaign, adset | **non esiste per inserzione** |
| video_p25_watched_actions | Video plays at 25% | tutti | lo stesso vale per `p50`, `p75` e `p100` |
| video_thruplay_watched_actions | ThruPlays | tutti | 15 secondi o fino alla fine |
| cost_per_thruplay | Cost per ThruPlay | tutti | |
| cost_per_2_sec_continuous_video_view | Cost per 2-second continuous video play | tutti | |
| video_avg_time_watched_actions | Video average play time | tutti | durata, non conteggio |
| post_save | Post saves | tutti | non filtrabile |
| post_shares | Post shares | account, campaign, adset | **non esiste per inserzione** |
| comment | Post comments | tutti | non filtrabile |
| post_reaction | Post reactions | tutti | |
| post_engagement | Post engagements | tutti | |
| instagram_profile_follow_v2 | Instagram follows | tutti | follower attribuiti alle inserzioni; non filtrabile |
| optimization_goal | performance goal | adset | enum; tra i valori c'è `VISIT_INSTAGRAM_PROFILE` |
| destination_type | destination type | adset | |
| targeting | targeting | adset | sola lettura: serve per controllare paese e posizioni |
| learning_stage_info | learning stage info | adset | |

Non esistono (verificato il 2026-11-19): un campo per le visite al profilo e un campo per il costo per follower. Le visite si leggono come `results` di un gruppo ottimizzato per le visite al profilo (da verificare alla prima campagna); il costo per follower si calcola come `amount_spent` ÷ `instagram_profile_follow_v2`.
