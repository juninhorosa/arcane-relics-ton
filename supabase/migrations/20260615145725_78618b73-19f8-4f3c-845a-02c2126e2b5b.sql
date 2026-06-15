
-- Lock down SECURITY DEFINER RPCs: revoke from anon, allow authenticated + service_role.
REVOKE EXECUTE ON FUNCTION public.calculate_player_power(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_player_max_hp(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_nation_player_counts() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.sync_offline_farm(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.update_nation_rivalry(uuid, uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.calculate_player_power(uuid) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_player_max_hp(uuid) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_nation_player_counts() TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.sync_offline_farm(uuid) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.update_nation_rivalry(uuid, uuid, int) TO authenticated, service_role;
