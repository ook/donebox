module EffectsHelper
  def wait_for_effects
    page << 'EffectWatcher.whenComplete(function() {'
    yield
    page << '});'
  end
end