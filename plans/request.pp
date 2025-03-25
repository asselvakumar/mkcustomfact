plan mkcustomfact::request (
  TargetSpec $targets
) {

  run_task('mkcustomfact::task1', $targets)

  run_task('mkcustomfact::task2', $targets)

  $api_key = lookup('mkcustomfact::api_key')
  #notify {"Running with api_key ${api_key} ID defined":}

  #$result  = run_task('mkcustomfact', $targets)
  $result  = run_task('mkcustomfact', $targets, 'api_key' => $api_key)
  return $result
}
