package com.epam.indigo.elastic;

import com.epam.indigo.Indigo;
import com.epam.indigo.IndigoException;
import com.epam.indigo.IndigoObject;
import com.epam.indigo.model.Helpers;
import com.epam.indigo.model.IndigoRecord;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Iterator;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class IterateOnFileTest {

    static Indigo indigo;

    @BeforeAll
    static void initIndigo() {
        indigo = new Indigo();
    }

    @Test
    @DisplayName("Testing iterator over sdf file")
    void testIterateSdf() throws Exception {

        String sdfFile = "src/test/resources/rand_queries_small.sdf";

        Iterable<IndigoRecord> indigoRecords = Helpers.iterateSdf(sdfFile);
        int count = 0;
        int succCount = 0;
        for (IndigoObject indigoObject : indigo.iterateSDFile(sdfFile)) {
            IndigoRecord currentIndigoRecord = indigoRecords.iterator().next();
            indigoObject.aromatize();
            try {
                assertEquals(
                        currentIndigoRecord.getIndigoObject(indigo).canonicalSmiles(),
                        indigoObject.canonicalSmiles());
                succCount++;
            } catch (IndigoException e) {
                // This is just fallback. Indigo is too strict
            }
            count++;
        }
        assertEquals(370, succCount);
        assertEquals(371, count);
    }

    @Test
    void testIterateSmiles() {
        String smilesFile = "src/test/resources/pubchem_slice_50.smi";

        Iterable<IndigoRecord> indigoRecords = Helpers.iterateSmiles(smilesFile);
        int count = 0;
        for (IndigoObject indigoObject : indigo.iterateSmilesFile(smilesFile)) {
            IndigoRecord currentIndigoRecord = indigoRecords.iterator().next();
            indigoObject.aromatize();
            assertEquals(
                    currentIndigoRecord.getIndigoObject(indigo).canonicalSmiles(),
                    indigoObject.canonicalSmiles());
            count++;
        }
        assertEquals(50, count);
    }

    @Test
    void testIterateCml() {
        String cmlFile = "src/test/resources/tetrahedral-all.cml";

        Iterable<IndigoRecord> indigoRecords = Helpers.iterateCml(cmlFile);
        int count = 0;
        for (IndigoObject indigoObject : indigo.iterateCMLFile(cmlFile)) {
            IndigoRecord currentIndigoRecord = indigoRecords.iterator().next();
            indigoObject.aromatize();
            assertEquals(
                    currentIndigoRecord.getIndigoObject(indigo).canonicalSmiles(),
                    indigoObject.canonicalSmiles());
            count++;
        }
        assertEquals(163, count);
    }

}
