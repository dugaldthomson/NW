import numpy as np

def spl(p_pa, ref='water', window_size=None, fs=None):
    """
    Calculate sound pressure level (in dB) of given pressure signal 'p_pa'.
    """
    if fs:
        window_size = int(window_size * fs)

    if ref == 'air':
        p_ref = 20e-6
    elif ref == 'water':
        p_ref = 1e-6
    else:
        p_ref = ref

    def calcspl(p_pa, p_ref):
        p_rms = np.sqrt(np.mean(p_pa**2))
        return 20 * np.log10(p_rms / p_ref)

    if window_size:
        # The following is a simplified version of the slidefun function
        spl_values = []
        for i in range(len(p_pa) - window_size + 1):
            spl_values.append(calcspl(p_pa[i:i+window_size], p_ref))
        return np.array(spl_values)
    else:
        return calcspl(p_pa, p_ref)

def deg2km(deg):
    """Converts degrees to kilometers."""
    return deg * 111.32

def calc_dist(lats, longs, array1, array2):
    """
    Calculates the distance and angle from an AIS contact to NW array nodes.
    """
    r1 = np.zeros((len(lats), array1.shape[0], 2))
    r2 = np.zeros((len(lats), array2.shape[0], 2))

    for j in range(len(lats)):
        # The following is a placeholder for the distance and azimuth calculation
        # You will need to replace this with a proper implementation
        arc1 = np.sqrt((lats[j] - array1[:, 0])**2 + (longs[j] - array1[:, 1])**2)
        az1 = np.arctan2(longs[j] - array1[:, 1], lats[j] - array1[:, 0])
        arc2 = np.sqrt((lats[j] - array2[:, 0])**2 + (longs[j] - array2[:, 1])**2)
        az2 = np.arctan2(longs[j] - array2[:, 1], lats[j] - array2[:, 0])

        r1[j, :, 0] = deg2km(arc1)
        r2[j, :, 0] = deg2km(arc2)
        r1[j, :, 1] = np.rad2deg(az1)
        r2[j, :, 1] = np.rad2deg(az2)

    return r1, r2

def calculate_source_level(rl, r, spread):
    """
    Calculates the source level from the received level and range.
    """
    tl = spread * np.log10(r)
    sl = rl + tl
    return sl
