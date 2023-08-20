resource "time_sleep" "wait_helm_runner" {
/*
I add this sleep because the runner pods take time to destroy
I don't find a good way to wait the runner pod destroy 
that's why i do that
*/
  depends_on = [ helm_release.gihtub_action ]
  destroy_duration = "2m"
}